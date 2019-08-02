require 'rails_helper'

RSpec.describe ProjectMembershipsController, type: :routing do
  describe 'routing' do
    it 'should route to #index' do
      expect(get: '/projects/1/project_memberships').to route_to(
        controller: 'project_memberships',
        action: 'index',
        project_id: '1'
      )
    end
    it 'should route to #create' do
      expect(post: '/project_memberships').to route_to(
        controller: 'project_memberships',
        action: 'create'
      )
    end
    it 'should route to #destroy' do
      expect(delete: '/project_memberships/1').to route_to(
        controller: 'project_memberships',
        action: 'destroy',
        id: '1'
      )
    end
    it 'should route to #search' do
      expect(get: '/project_memberships/search').to route_to(
        controller: 'project_memberships',
        action: 'search'
      )
    end
  end
end
