ActiveAdmin.register Reward do
  permit_params :name,
                :project_id,
                :blurb,
                :threshold,
                :limited,
                :total_stock
end
