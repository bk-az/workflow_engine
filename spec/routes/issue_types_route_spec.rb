require 'rails_helper'

RSpec.describe IssueTypesController, type: :routing do
  describe 'routing' do
    it 'should route to #index' do
      expect(get: '/issue_types').to route_to(
        controller: 'issue_types',
        action: 'index'
      )
    end
    it 'should route to #index' do
      expect(get: 'projects/1/issue_types').to route_to(
        controller: 'issue_types',
        action: 'index',
        project_id: '1'
      )
    end
    it 'should route to #show' do
      expect(get: '/issue_types/1').to route_to(
        controller: 'issue_types',
        action: 'show',
        id: '1'
      )
    end
    it 'should route to #create' do
      expect(post: '/issue_types').to route_to(
        controller: 'issue_types',
        action: 'create'
      )
    end
    it 'should route to #create' do
      expect(post: 'projects/1/issue_types').to route_to(
        controller: 'issue_types',
        action: 'create',
        project_id: '1'
      )
    end
    it 'should route to #edit' do
      expect(get: '/issue_types/1/edit').to route_to(
        controller: 'issue_types',
        action: 'edit',
        id: '1'
      )
    end
    it 'should route to #update' do
      expect(patch: '/issue_types/1').to route_to(
        controller: 'issue_types',
        action: 'update',
        id: '1'
      )
    end
    it 'should route to #destroy' do
      expect(delete: '/issue_types/1').to route_to(
        controller: 'issue_types',
        action: 'destroy',
        id: '1'
      )
    end
  end
end
