require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password', name: 'Test User', user_type: 'Manager') }
  let!(:project) { Project.create!(name: 'Test Project', description: 'Project Description', user_id: user.id) }
  let(:params) do
    { 
      name: 'Test Project 1', 
      description: 'Project Description 1', 
      user_id: user.id,
    }
  end

  let(:invalid_params) do
    { 
      name: 'Test Project 1', 
      user_id: user.id,
    }
  end


  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'redirects to projects_path' do
      get :index
			expect(Project.count).to eq(1)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new project' do
        allow(controller).to receive(:authorize_manager)
        post :create, params: { project: params }
        expect(Project.count).to eq(2)
        expect(Project.last.name).to eq('Test Project 1')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a project' do
        post :create, params: { project: invalid_params }
        expect(Project.count).to eq(1)
      end
    end
  end

  describe '#update' do
    it 'updates project' do
      allow(controller).to receive(:authorize_project_creator)
			allow(controller).to receive(:authorize_manager)
      put :update, params: { id: project.id, project: { name: 'Update Test Project 1'} }
      expect(Project.count).to eq(1)
      expect(Project.last.name).to eq('Update Test Project 1')
    end
  end

  describe 'private methods' do
    describe '#authorize_manager' do
      it 'redirects to root_path if user cannot create a bug' do
        allow(controller).to receive(:can?).and_return(false)
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(root_path)
      end
    end

    describe '#find_project' do
      it 'finds the bug by id' do
        get :show, params: { id: project.id }
        expect(assigns(:project)).to eq(project)
      end
    end
  end
end
