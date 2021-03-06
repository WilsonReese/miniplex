class LocationsController < ApplicationController
  def index
    matching_locations = Location.all

    @list_of_locations = matching_locations.order({ :created_at => :desc })

    render({ :template => "locations/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_locations = Location.where({ :id => the_id })

    @the_location = matching_locations.at(0)

    render({ :template => "locations/show.html.erb" })
  end

  def create
    the_location = Location.new
    the_location.street_address = params.fetch("query_street_address")
    the_location.location_name = params.fetch("query_location_name")
    the_location.open_time = params.fetch("query_open_time")
    the_location.close_time = params.fetch("query_close_time")

    if the_location.valid?
      the_location.save
      redirect_to("/locations", { :notice => "Location created successfully." })
    else
      redirect_to("/locations", { :notice => "Location failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_location = Location.where({ :id => the_id }).at(0)

    the_location.street_address = params.fetch("query_street_address")
    the_location.location_name = params.fetch("query_location_name")
    # the_location.open_time = Time.new(2000, 01, 01, 8, 0, 0, "-06:00")
    the_location.open_time = params.fetch("query_open_time")
    the_location.close_time = params.fetch("query_close_time")

    if the_location.valid?
      the_location.save
      redirect_to("/locations/#{the_location.id}", { :notice => "Location updated successfully."} )
    else
      redirect_to("/locations/#{the_location.id}", { :alert => "Location failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_location = Location.where({ :id => the_id }).at(0)

    the_location.destroy

    redirect_to("/locations", { :notice => "Location deleted successfully."} )
  end
end
