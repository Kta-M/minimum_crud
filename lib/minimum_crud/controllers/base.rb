module MinimumCrud
  module Controllers
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :sub_layout
        self.sub_layout = :application

        class_attribute :enable_json
        self.enable_json = false

        class_attribute :permit_params
        model = self.to_s.gsub(/Controller\Z/, '').classify.constantize
        self.permit_params =
          model.column_names.map(&:to_sym) - [:id, :created_at, :updated_at]

        before_action :set_model
        before_action :set_record, only: [:show, :edit, :update, :destroy]
      end

      class_methods do
        def minimum_crud_sub_layout(name)
          self.sub_layout = name
        end
        def minimum_crud_enable_json(is_enable)
          self.enable_json = is_enable
        end
        def minimum_crud_permit_params(*permit_params)
          self.permit_params = permit_params
        end
      end

      def index
        @records = @model.all
        respond_to do |format|
          format.html { render sub_layout_path }
          if self.enable_json
            format.json { }
          end
        end
      end

      def show
        respond_to do |format|
          format.html { render sub_layout_path }
          if self.enable_json
            format.json { }
          end
        end
      end

      def new
        @record = @model.new
        render sub_layout_path
      end

      def edit
        render sub_layout_path
      end

      def create
        @record = @model.new(record_params)

        respond_to do |format|
          if @record.save
            format.html { redirect_to ({action: :show, id: @record}),
                          notice: message_on_create(@record) }
            if self.enable_json
              format.json { render :show, status: :created, location: @record }
            end
          else
            format.html { render sub_layout_path(:new) }
            if self.enable_json
              format.json { render json: @record.errors, status: :unprocessable_entity }
            end
          end
        end
      end

      def update
        respond_to do |format|
          if @record.update(record_params)
            format.html { redirect_to ({action: :show, id: @record}),
                          notice: message_on_update(@record) }
            if self.enable_json
              format.json { render :show, status: :ok, location: @record }
            end
          else
            format.html { render sub_layout_path(:edit) }
            if self.enable_json
              format.json { render json: @record.errors, status: :unprocessable_entity }
            end
          end
        end
      end

      def destroy
        @record.destroy
        respond_to do |format|
          format.html { redirect_to ({action: :index}),
                        notice: message_on_destroy(@record) }
          if self.enable_json
            format.json { head :no_content }
          end
        end
      end

      def sub_layout_path(action = nil)
        action ||= action_name
        if self.class.sub_layout.try(:to_sym) == :none
          action
        else
          "layouts/minimum_crud/#{self.class.sub_layout}/#{action}"
        end
      end

      private
      def set_model
        @model = self.class.to_s.gsub(/Controller\Z/, '').classify.constantize
      end
      def set_record
        @record = @model.find(params[:id])
      end
      def record_params
        params.require(@model.model_name.name.underscore)
              .permit(self.permit_params)
      end

      def message_on_create(_record)
        I18n.t('helpers.created', model: @model.model_name.human)
      end
      def message_on_update(_record)
        I18n.t('helpers.updated', model: @model.model_name.human)
      end
      def message_on_destroy(_record)
        I18n.t('helpers.deleted', model: @model.model_name.human)
      end

    end
  end
end
