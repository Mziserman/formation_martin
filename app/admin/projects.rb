# frozen_string_literal: true

ActiveAdmin.register Project do
  # form do |f|
  #   f.inputs "Firmware" do
  #     f.input :thumbnail, as: :photo
  #   end
  #   f.actions
  # end

  # form do |f|
  #   f.inputs 'Thumbnail' do
  #     binding.pry
  #     f.semantic_fields_for :thumbnail do |c|
  #       c.inputs 'Attachment' do

  #         if c.object.cover_page.present?
  #           c.input :image, as: :file, hint: image_tag(c.object.image.url(:thumb))
  #         else
  #           c.input :image, as: :file, hint: content_tag(:span, 'no cover page yet')
  #         end
  #         c.input :image_cache, as: :hidden
  #       end
  #     end
  #   end
  #   f.actions
  # end

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
        a.input :image, as: :file
      end
    end
    # f.inputs do
    #   f.has_many :taggings, sortable: :position, sortable_start: 1 do |t|
    #     t.input :tag
    #   end
    # end
    # f.inputs do
    #   f.has_many :comment,
    #              new_record: 'Leave Comment',
    #              allow_destroy: -> (c) { c.author?(current_admin_user) } do |b|
    #     b.input :body
    #   end
    # end
    f.actions
  end

end
