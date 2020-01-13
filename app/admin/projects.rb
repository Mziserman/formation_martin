# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted_in_cents,
                :category_list,
                :thumbnail,
                :landscape,
                :thumbnail_data,
                :landscape_data

  controller do
    def update(options = {}, &block)
      if permitted_params[:project][:thumbnail_data].blank?
        params[:project][:thumbnail_data] = nil
      end
      if permitted_params[:project][:landscape_data].blank?
        params[:project][:landscape_data] = nil
      end

      super
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :amount_wanted_in_cents
      f.input :small_blurb
      f.input :long_blurb
      f.input :categories

      if f.object.thumbnail.present?
        f.input :thumbnail, as: :file, hint: image_tag(f.object.thumbnail.url)
        f.button Project.human_attribute_name(:remove_thumbnail),
                 class: 'remove_thumbnail'
      else
        f.input :thumbnail, as: :file, hint: content_tag(:span, 'no cover page yet')
      end
      f.input :thumbnail_data, as: :hidden

      if f.object.landscape.present?
        f.input :landscape, as: :file, hint: image_tag(f.object.landscape.url)
        f.button Project.human_attribute_name(:remove_landscape),
                 class: 'remove_landscape'
      else
        f.input :landscape, as: :file, hint: content_tag(:span, 'no cover page yet')
      end
      f.input :landscape_data, as: :hidden
    end

    f.actions
  end
end
