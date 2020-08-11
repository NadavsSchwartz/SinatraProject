class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :flight
end
# display all user's wishlist flights, in a styled card panel, with option to remove or edit
# make sure only current user has access to his wishlist flights
