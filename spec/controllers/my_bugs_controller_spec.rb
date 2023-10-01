require 'rails_helper'

RSpec.describe MyBugsController, type: :controller do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password', name: 'Test User', user_type: 'Manager') }
  let!(:project) { Project.create!(name: 'Test Project', description: 'Project Description', user_id: user.id) }
  let!(:bug) { MyBug.create!(title: 'Test Bug', description: 'Bug Description', user_id: user.id, project_id: project.id, bug_type: 'bug', status: 'new', deadline: Date.today + 1) }
  let(:params) do
    { 
      title: 'Test Bug 1', 
      description: 'Bug Description 1', 
      user_id: user.id, 
      project_id: project.id,
      bug_type: 'bug',
      status: 'started',
      deadline: Date.today + 1,
    }
  end

  let(:invalid_params) do
    { 
      title: 'Test Bug 2', 
      description: 'Bug Description 1', 
      user_id: user.id, 
      project_id: project.id,
      bug_type: 'bug',
      deadline: Date.today + 1,
    }
  end


  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'redirects to projects_path' do
      get :index
      expect(response).to redirect_to(projects_path)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new bug' do
        allow(controller).to receive(:authorize_create_bug)
        post :create, params: { my_bug: params }
        expect(MyBug.count).to eq(2)
        expect(MyBug.last.title).to eq('Test Bug 1')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a bug' do
        post :create, params: { my_bug: invalid_params }
        expect(MyBug.count).to eq(1)
      end
    end
  end

  describe '#update' do
    it 'updates bug' do
      allow(controller).to receive(:authorize_update_bug)
      patch :update, params: { id: bug.id, my_bug: { title: 'Update Test Bug 1'} }
      expect(MyBug.count).to eq(1)
      expect(MyBug.last.title).to eq('Update Test Bug 1')
    end
  end

  describe 'private methods' do
    describe '#authorize_create_bug' do
      it 'redirects to root_path if user cannot create a bug' do
        allow(controller).to receive(:can?).and_return(false)
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(root_path)
      end
    end

    describe '#find_bug' do
      it 'finds the bug by id' do
        get :show, params: { id: bug.id }
        expect(assigns(:bug)).to eq(bug)
      end
    end

    describe '#authorize_update_bug' do
      it 'redirects to root_path if user cannot update the bug' do
        allow(controller).to receive(:can_update_bug).and_return(false)
        get :edit, params: { id: bug.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
