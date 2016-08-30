module Admin
  class GroupsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Group.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Group.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def history
      render xlsx: "history", filename: "#{requested_resource.name} #{Time.zone.now.to_s(:number)}.xlsx"
    end

    def unsync
      Flows::UnsyncService.new(requested_resource).run!
      redirect_to [namespace, requested_resource], notice: "All routines of #{requested_resource.name} were successfully unsynced."
    end

    def resync
      Flows::ResyncService.new(requested_resource).run!
      redirect_to [namespace, requested_resource], notice: "All routines of #{requested_resource.name} were successfully resynced."
    end
  end
end
