# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted_in_cents,
                :category_list,
                :thumbnail,
                :landscape

  controller do
    def update(options = {}, &block)
      # if permitted_params[:project][:thumbnail].blank?
      #   params[:project][:thumbnail] = nil
      # end
      # if permitted_params[:project][:landscape].blank?
      #   params[:project][:landscape] = ''
      # end
      # binding.pry

      super
    end
  end

  show do
    attributes_table do
      row :name
      row :small_blurb
      row :long_blurb
      row :amount_wanted_in_cents
      row :categories
      row :thumbnail do |project|
        if project.thumbnail.present?
          image_tag(project.thumbnail.url, height: 250)
        end
      end
      row :landscape do |project|
        if project.landscape.present?
          image_tag(project.landscape.url, height: 250)
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    inputs do
      f.input :name
      f.input :amount_wanted_in_cents
      f.input :small_blurb
      f.input :long_blurb
      f.input :categories

      f.input :thumbnail,
              as: :hidden,
              input_html: { value: f.object.cached_thumbnail_data }

      if f.object.thumbnail.present?
        f.input :thumbnail, as: :file, hint: image_tag(f.object.thumbnail.url)
        f.button Project.human_attribute_name(:remove_thumbnail),
                 class: 'remove_thumbnail'
      else
        f.input :thumbnail, as: :file, hint: content_tag(:span, 'no cover page yet')
      end

      f.input :landscape,
              as: :hidden,
              input_html: { value: f.object.cached_landscape_data }
      if f.object.landscape.present?
        f.input :landscape, as: :file, hint: image_tag(f.object.landscape.url)
        f.button Project.human_attribute_name(:remove_landscape),
                 class: 'remove_landscape'
      else
        f.input :landscape, as: :file, hint: content_tag(:span, 'no cover page yet')
      end
    end

    f.actions
  end
end
