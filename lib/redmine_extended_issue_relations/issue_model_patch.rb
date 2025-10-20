
module RedmineExtendedIssueRelations
  module IssueModelPatch
    def self.included(base)
      base.class_eval do
         prepend ClassMethods
      end
    end

    module ClassMethods
      
      def workflow_rule_by_attribute(user=nil)
        return @workflow_rule_by_attribute if @workflow_rule_by_attribute && user.nil?

        roles = roles_for_axn_workflow(user || User.current)
        return {} if roles.empty?

        result = {}
        workflow_permissions =
          WorkflowPermission.where(
            :tracker_id => tracker_id, :old_status_id => status_id,
            :role_id => roles.map(&:id)
          ).to_a
        if workflow_permissions.any?
          workflow_rules = workflow_permissions.inject({}) do |h, wp|
            h[wp.field_name] ||= {}
            h[wp.field_name][wp.role_id] = wp.rule
            h
          end
          fields_with_roles = {}
          IssueCustomField.where(:visible => false).
            joins(:roles).pluck(:id, "role_id").
              each do |field_id, role_id|
            fields_with_roles[field_id] ||= []
            fields_with_roles[field_id] << role_id
          end
          roles.each do |role|
            fields_with_roles.each do |field_id, role_ids|
              unless role_ids.include?(role.id)
                field_name = field_id.to_s
                workflow_rules[field_name] ||= {}
                workflow_rules[field_name][role.id] = 'readonly'
              end
            end
          end
          workflow_rules.each do |attr, rules|
            next if rules.size < roles.size

            uniq_rules = rules.values.uniq
            if uniq_rules.size == 1
              result[attr] = uniq_rules.first
            else
              result[attr] = 'required'
            end
          end
        end
        @workflow_rule_by_attribute = result if user.nil?
        result
      end

      def roles_for_workflow(user)
        roles = user.roles_for_project(project)
        roles.select(&:consider_workflow?)
      end
    end
  end
end

Issue.send(:include, RedmineExtendedIssueRelations::IssueModelPatch)