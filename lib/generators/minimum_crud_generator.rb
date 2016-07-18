class MinimumCrudGenerator < Rails::Generators::NamedBase
  desc 'Generate a controller and views using minimum_crud'
  source_root File.expand_path('../templates', __FILE__)

  class_option :sub_layout,    type: :string,  aliases: "-l", desc: ''
  class_option :enable_json,   type: :boolean, aliases: "-j", desc: ''
  class_option :permit_params, type: :array,   aliases: "-p", desc: ''

  check_class_collision suffix: "Controller"

  def generate_controller_files
    template 'controller.rb.erb', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
  end

  def copy_layout_files
    return unless use_sub_layout?

    sub_layout = options[:sub_layout] || 'application'

    %w(_form index show new edit).each do |action|
      copy_file "layouts/#{action}.html.erb",
                File.join('app/views/layouts/minimum_crud', sub_layout, "#{action}.html.erb")
    end
  end

  def generate_view_files
    @attributes = options[:permit_params] ||
                  model.attribute_names - ["id", "created_at", "updated_at"]

    if use_sub_layout?
      %w(_form _index _show).each do |action|
        template "views/with_sub_layout/#{action}.html.erb",
                 File.join('app/views', class_path, file_name, "#{action}.html.erb")
      end
    else
      %w(_form index show edit new).each do |action|
        template "views/without_sub_layout/#{action}.html.erb",
                 File.join('app/views', class_path, file_name, "#{action}.html.erb")
      end
    end
  end

  def generate_jbuilder_files
    return unless enable_json?

    @attributes_argument = @attributes.map{|a| ":#{a}"}.join(', ')
    %w(index show).each do |action|
      template "views/#{action}.json.jbuilder.erb",
               File.join('app/views', class_path, file_name, "#{action}.json.jbuilder")
    end
  end

  private

  def model
    class_name.gsub(/\A.*::/, '').classify.constantize
  end

  def use_sub_layout?
    options[:sub_layout] != 'none'
  end

  def enable_json?
    options[:enable_json]
  end
end
