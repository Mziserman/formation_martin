# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted_in_cents,
                :category_list,
                :thumbnail,
                :landscape
                # thumbnail_attributes: %i[id image _destroy],
                # landscape_attributes: %i[id image _destroy]

  # form do |f|
  #   f.inputs do
  #     f.has_many :thumbnail, heading: 'Thumbnail',
  #                            allow_destroy: true,
  #                            new_record: !f.object.thumbnail.present? do |a|
  #       a.input :image, as: :hidden
  #       if a.object.image.present?
  #         a.input :image, as: :file, hint: image_tag(a.object.image.url)
  #       else
  #         a.input :image, as: :file, hint: content_tag(:span, 'no cover page yet')
  #       end
  #     end
  #   end

  #   f.actions
  # end
end
