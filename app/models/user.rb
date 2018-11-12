class User < ApplicationRecord
  rolify before_add: :remove_existing_roles

  has_secure_password

  validates :email, presence: true, uniqueness: true

  private

  def remove_existing_roles
    if self.roles
      self.roles.each do |role|
        self.remove_role role.name
      end
    end
  end

end
