require 'rails_helper'

RSpec.describe IssueStatesController, type: :routing do
  describe 'routing' do
    it 'should route to #index' do
      expect(get: '/issue_states').to route_to(
        controller: 'issue_states',
        action: 'index'
      )
    end
    it 'should route to #show' do
      expect(get: '/issue_states/1').to route_to(
        controller: 'issue_states',
        action: 'show',
        id: '1'
      )
    end
    it 'should route to #create' do
      expect(post: '/issue_states').to route_to(
        controller: 'issue_states',
        action: 'create'
      )
    end
    it 'should route to #edit' do
      expect(get: '/issue_states/1/edit').to route_to(
        controller: 'issue_states',
        action: 'edit',
        id: '1'
      )
    end
    it 'should route to #update' do
      expect(patch: '/issue_states/1').to route_to(
        controller: 'issue_states',
        action: 'update',
        id: '1'
      )
    end
    it 'should route to #destroy' do
      expect(delete: '/issue_states/1').to route_to(
        controller: 'issue_states',
        action: 'destroy',
        id: '1'
      )
    end
  end
end
