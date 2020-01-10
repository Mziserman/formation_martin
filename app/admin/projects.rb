# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted_in_cents,
                :category_list,
                thumbnail_attributes: %i[image],
                landscape_attributes: %i[image]

  form do |f|
    f.inputs do
      f.has_many :thumbnail, heading: 'Thumbnail',
                             allow_destroy: false,
                             new_record: true do |a|
        if a.object.image.present?
          a.input :image, as: :file, hint: image_tag(a.object.image.url)
        else
          a.input :image, as: :file, hint: content_tag(:span, 'no cover page yet')
        end
        a.input :image, as: :hidden
      end
    end

    f.actions
  end
end
