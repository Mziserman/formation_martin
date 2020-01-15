# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted,
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

  show do
    render 'show', project: project

    panel 'Donations' do
      table_for project.contributions do
        column 'Nom du donateur' do |contribution|
          link_to contribution.user.name, admin_user_path(contribution.user)
        end
        column 'Donation' do |contribution|
          currency_print(contribution.amount)
        end
        column 'Contrepartie' do |contribution|
          contribution.reward&.name
        end
        column :created_at
      end
    end

    panel 'Contreparties' do
      table_for project.rewards do
        column :name
        column :threshold do |reward|
          currency_print(reward.threshold)
        end
        column :total_stock do |reward|
          reward.stock == Float::INFINITY ? 'Non limité' : reward.stock
        end
        column :actions do |reward|
          span link_to 'edit', edit_admin_reward_path(reward)
          span link_to 'delete', admin_reward_path(reward),
                       rel: 'nofollow',
                       'data-method' => :delete,
                       'data-confirm' => 'Voulez-vous vraiment supprimer ceci ?'
        end
      end
    end

    attributes_table do
      row :name
      row :small_blurb
      row :long_blurb
      row :amount_wanted do |contribution|
        currency_print(contribution.amount_wanted)
      end
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
  end

  form do |f|
    inputs do
      f.input :name
      f.input :amount_wanted
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
