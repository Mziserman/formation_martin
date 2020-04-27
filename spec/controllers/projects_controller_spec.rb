# frozen_string_literal: true

describe ProjectsController, '#index', type: :controller do
  let!(:project_name) { create(:project, name: 'name') }
  let!(:project_small_blurb) { create(:project, small_blurb: 'small_blurb') }
  let!(:project_long_blurb) { create(:project, long_blurb: 'long_blurb') }
  let!(:project_owner) do
    create(:project, :with_owner, owner: build(:admin_user, first_name: 'owner'))
  end
  let!(:project_category) do
    create :project, :with_categories, categories: ['category']
  end
  let!(:project_ongoing) do
    project = create :project,
                     :with_thumbnail,
                     :with_landscape,
                     :with_rewards,
                     :with_categories
    project.start_publication
    project.finish_publication
    project.save

    project
  end

  subject do
    get :index, params: params
  end

  context 'logged as an admin, searching name' do
    login_admin_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'name'
        }
      }
    end

    it 'assigns name project' do
      subject
      expect(assigns(:projects)).to include(project_name)
    end
  end

  context 'logged as an admin, searching blurb' do
    login_admin_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'blurb'
        }
      }
    end

    it 'assigns blurb projects' do
      subject
      expect(assigns(:projects)).to include(project_small_blurb)
      expect(assigns(:projects)).to include(project_long_blurb)
    end
  end

  context 'logged as an admin, searching owner' do
    login_admin_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'owner'
        }
      }
    end

    it 'assigns owner project' do
      subject
      expect(assigns(:projects)).to include(project_owner)
    end
  end

  context 'logged as an admin, searching owner and draft' do
    login_admin_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'owner',
          aasm_state_eq: 'draft'
        }
      }
    end

    it 'assigns owner project' do
      subject
      expect(assigns(:projects)).to include(project_owner)
    end
  end

  context 'logged as an admin, searching owner and ongoing' do
    login_admin_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'owner',
          aasm_state_eq: 'ongoing'
        }
      }
    end

    it 'assigns no project' do
      subject
      expect(assigns(:projects)).to eq []
    end
  end

  context 'logged as an admin, searching owner and ongoing' do
    login_admin_user
    let(:params) do
      {
        q: {
          categories: ['category']
        }
      }
    end

    it 'assigns category project' do
      subject
      expect(assigns(:projects)).to include(project_category)
    end
  end

  context 'logged as a user, searching owner' do
    login_user
    let(:params) do
      {
        q: {
          name_or_small_blurb_or_long_blurb_or_owners_first_name_or_owners_last_name_cont: 'owner'
        }
      }
    end

    it 'does not show drafts' do
      subject
      expect(assigns(:projects)).to eq []
    end
  end

  context 'logged as a user' do
    login_user
    let(:params) {}

    it 'only shows not draft project' do
      subject
      expect(assigns(:projects)).to eq [project_ongoing]
    end
  end
end
