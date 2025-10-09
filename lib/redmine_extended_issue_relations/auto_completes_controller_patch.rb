
module RedmineExtendedIssueRelations
  module AutoCompletesControllerPatch
    def self.included(base)
      base.class_eval do
         prepend ClassMethods
      end
    end

    module ClassMethods
      def issues
        issues = []
        q = (params[:q] || params[:term]).to_s.strip
        status = params[:status].to_s
        issue_id = params[:issue_id].to_s

        scope = Issue.cross_project_scope(@project, params[:scope]).includes(:tracker).visible
        scope = scope.open(status == 'o') if status.present?
        scope = scope.where.not(:id => issue_id.to_i) if issue_id.present?
        if q.present?
          if q =~ /\A#?(\d+)\z/
            issues << scope.find_by(:id => $1.to_i)
          end
          issues += scope.like(q).order(:id => :desc).limit(10).to_a
          issues += scope.joins(:project).where("projects.name like ?", "%" + q + "%").order(:id => :desc).limit(10).to_a
          issues.compact!
        else
          issues += scope.order(:id => :desc).limit(10).to_a
        end

        render :json => format_issues_json(issues)
      end

      def format_issues_json(issues)
        issues.map do |issue|
          {
            'id' => issue.id,
            'label' => "[#{issue.project.name}] #{issue.tracker} ##{issue.id}: #{issue.subject.to_s.truncate(255)}",
            'value' => issue.id
          }
        end
      end
    end
  end
end

AutoCompletesController.send(:include, RedmineExtendedIssueRelations::AutoCompletesControllerPatch)