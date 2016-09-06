class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # Make a request to the Caren API and assign the response
    response = current_user.access_token.get("api/v1/people", params: {
      receive_care_from: current_user.uid
    })

    # Parse the response of the patients API call so it's usable
    @patients = JSON.parse(response.body)["_embedded"]
  end

end
