authorization do
  role :api_whitelist do
    has_permission_on :api_v0_courses, :to => :manage
    has_permission_on :api_v0_terms, :to => :manage
    has_permission_on :api_v0_departments, :to => :manage
  end
  
  role :api_key do
    has_permission_on :api_v0_courses, :to => :read
    has_permission_on :api_v0_terms, :to => :read
    has_permission_on :api_v0_departments, :to => :read
  end
  
  role :access do
    has_permission_on :api_v0_courses, :to => :read
    has_permission_on :api_v0_terms, :to => :read
    has_permission_on :api_v0_departments, :to => :read
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
