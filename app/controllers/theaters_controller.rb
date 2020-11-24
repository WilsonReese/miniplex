class TheatersController < ApplicationController
  def index
    matching_theaters = Theater.all

    @list_of_theaters = matching_theaters.order({ :created_at => :desc })

    render({ :template => "theaters/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_theaters = Theater.where({ :id => the_id })

    @the_theater = matching_theaters.at(0)

    render({ :template => "theaters/show.html.erb" })
  end

  def create
    the_theater = Theater.new
    the_theater.seats_in_theater = params.fetch("query_seats_in_theater")
    the_theater.location_id = params.fetch("query_location_id")
    the_theater.turnover_time = params.fetch("query_turnover_time")

    if the_theater.valid?
      the_theater.save
      redirect_to("/theaters", { :notice => "Theater created successfully." })
    else
      redirect_to("/theaters", { :notice => "Theater failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_theater = Theater.where({ :id => the_id }).at(0)

    the_theater.seats_in_theater = params.fetch("query_seats_in_theater")
    the_theater.location_id = params.fetch("query_location_id")
    the_theater.turnover_time = params.fetch("query_turnover_time")

    if the_theater.valid?
      the_theater.save
      redirect_to("/theaters/#{the_theater.id}", { :notice => "Theater updated successfully."} )
    else
      redirect_to("/theaters/#{the_theater.id}", { :alert => "Theater failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_theater = Theater.where({ :id => the_id }).at(0)

    the_theater.destroy

    redirect_to("/theaters", { :notice => "Theater deleted successfully."} )
  end
end
