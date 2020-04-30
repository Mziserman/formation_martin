# frozen_string_literal: true

ActiveAdmin.register Reward do
  permit_params :name,
                :project_id,
                :blurb,
                :threshold,
                :limited,
                :total_stock

  controller do
    def update(_options = {})
      resource.assign_attributes(permitted_params[:reward])
      resource.threshold = permitted_params[:reward][:threshold].to_f * 100
      Rewards::SaveTransaction.new.call(
        resource: resource
      ) do |transaction|
        transaction.success do |output|
          redirect_to admin_reward_path(output[:resource])
        end

        transaction.failure do |output|
          @resource = output[:resource]

          render 'edit', resource: @resource
        end
      end
    end

    def create(_options = {})
      resource = Reward.new(permitted_params[:reward])
      resource.threshold = permitted_params[:reward][:threshold].to_f * 100
      Rewards::SaveTransaction.new.call(
        resource: resource
      ) do |transaction|
        transaction.success do |output|
          redirect_to admin_reward_path(output[:resource])
        end

        transaction.failure do |output|
          @resource = output[:resource]

          render 'new', resource: @resource
        end
      end
    end
  end


  show do
    attributes_table do
      row :name
      row :blurb
      row :threshold do |reward|
        currency_print(reward.threshold)
      end
      row :total_stock do |reward|
        reward.stock == Float::INFINITY ? 'Non limité' : reward.stock
      end
    end
  end

  form do |f|
    inputs do
      f.input :name
      f.input :threshold, input_html: {
        value: f.object.threshold ? f.object.threshold.to_f / 100 : nil
      }
      f.input :blurb
      f.input :limited
      f.input :total_stock
    end

    f.actions
  end
end
