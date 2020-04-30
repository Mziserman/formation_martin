# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params :name,
                :small_blurb,
                :long_blurb,
                :amount_wanted,
                :category_list,
                :thumbnail,
                :remove_thumbnail,
                :landscape,
                :remove_landscape,
                :active_admin_requested_event,
                category_list: []

  filter :name
  filter :aasm_state, as: :check_boxes, collection: proc { Project.aasm.states.map &:name }
  filter :amount_wanted
  filter :created_at

  action_item :export_donations, only: :show do
    link_to 'Exporter les donations en csv',
            admin_project_contributions_path(project, format: :csv)
  end
  action_item :export_donators, only: :show do
    link_to 'Exporter les donateurs en csv',
            contributors_admin_project_path(project, format: :csv)
  end

  member_action :contributors, method: :get do
    respond_to do |format|
      format.csv do
        Users::ContributorsCsvTransaction.new.call(
          resource: resource
        ) do |transaction|
          transaction.success do |csv|
            send_data csv, filename: "contributors-#{DateTime.now.to_i}.csv"
          end
          transaction.failure do
            render 'show', resource: resource
          end
        end
      end
    end
  end

  controller do
    def update(_options = {})
      resource.assign_attributes(permitted_params[:project])
      resource.amount_wanted = permitted_params[:project][:amount_wanted].to_f * 100
      Projects::SaveTransaction.new.call(
        resource: resource,
        params: permitted_params[:project]
      ) do |transaction|
        transaction.success do |output|
          redirect_to admin_project_path(output[:resource])
        end

        transaction.failure do |output|
          @resource = output[:resource]

          render 'edit', resource: @resource
        end
      end
    end

    def create(_options = {})
      resource = Project.new(permitted_params[:project])
      resource.amount_wanted = permitted_params[:project][:amount_wanted].to_f * 100
      resource.owners << current_admin_user
      Projects::CreateTransaction.new.call(
        resource: resource
      ) do |transaction|
        transaction.success do |output|
          redirect_to admin_project_path(output[:resource])
        end

        transaction.failure do |output|
          @resource = output[:resource]

          render 'new', resource: @resource
        end
      end
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
        column 'Status', &:state
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
      row :aasm_state
      row :small_blurb
      row :long_blurb
      row :amount_wanted do |project|
        currency_print(project.amount_wanted)
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
      f.input :amount_wanted, input_html: {
        value: f.object.amount_wanted ? f.object.amount_wanted.to_f / 100 : nil
      }
      f.input :small_blurb
      f.input :long_blurb
      f.input :category_list, input_html: { value: f.object.category_list.to_s }

      f.input :thumbnail,
              as: :hidden,
              input_html: { value: f.object.cached_thumbnail_data }
      if f.object.thumbnail.present?
        f.input :thumbnail, as: :file, hint: image_tag(f.object.thumbnail.url)
        f.input :remove_thumbnail, as: :boolean
      else
        f.input :thumbnail, as: :file, hint: content_tag(:span, 'no cover page yet')
      end

      f.input :landscape,
              as: :hidden,
              input_html: { value: f.object.cached_landscape_data }
      if f.object.landscape.present?
        f.input :landscape, as: :file, hint: image_tag(f.object.landscape.url)
        f.input :remove_landscape, as: :boolean
      else
        f.input :landscape, as: :file, hint: content_tag(:span, 'no cover page yet')
      end

      f.input :aasm_state, input_html: { disabled: true }, label: 'Current state'
      f.input :active_admin_requested_event, label: 'Change state', as: :select, collection: f.object.aasm.events(permitted: true).map(&:name)
    end

    f.actions
  end
end
