class GroupReservationsController < ApplicationController
  def index
    matching_group_reservations = GroupReservation.all

    @list_of_group_reservations = matching_group_reservations.order({ :created_at => :desc })

    render({ :template => "group_reservations/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_group_reservations = GroupReservation.where({ :id => the_id })

    @the_group_reservation = matching_group_reservations.at(0)

    render({ :template => "group_reservations/show.html.erb" })
  end

  def create
    the_group_reservation = GroupReservation.new
    #status defaults to requested, not a user input
    the_group_reservation.reservation_status = "requested"

    #chosen by user
    the_group_reservation.reservation_date = params.fetch("query_reservation_date")
    the_group_reservation.reservation_time = params.fetch("query_reservation_time")
    the_group_reservation.number_of_tickets = params.fetch("query_number_of_tickets")
    
    # movie needs to come from the previous click
    the_group_reservation.movie_id = params.fetch("query_movie_id")

    # theater comes from availability
    the_group_reservation.theater_id = params.fetch("query_theater_id")

    #duration = movie.duration + theater.turnover_time
    the_group_reservation.reservation_duration = params.fetch("query_reservation_duration")

    # need custom validation for if theater is available is open
    # if theater is not open, we need to suggest new times, -- redirect to a new page? send an alert?
    # if reservation is valid, reservation status becomes confirmed (calculates reservation duration, blocks off theater, sends tickets)
    if the_group_reservation.valid?
      the_group_reservation.save
      redirect_to("/group_reservations", { :notice => "Group reservation created successfully." })
    else
      redirect_to("/group_reservations", { :notice => "Group reservation failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_group_reservation = GroupReservation.where({ :id => the_id }).at(0)

    the_group_reservation.reservation_status = params.fetch("query_reservation_status")
    the_group_reservation.reservation_date = params.fetch("query_reservation_date")
    the_group_reservation.reservation_time = params.fetch("query_reservation_time")
    the_group_reservation.reservation_duration = params.fetch("query_reservation_duration")
    the_group_reservation.number_of_tickets = params.fetch("query_number_of_tickets")
    the_group_reservation.movie_id = params.fetch("query_movie_id")
    the_group_reservation.theater_id = params.fetch("query_theater_id")

    if the_group_reservation.valid?
      the_group_reservation.save
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :notice => "Group reservation updated successfully."} )
    else
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :alert => "Group reservation failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_group_reservation = GroupReservation.where({ :id => the_id }).at(0)

    the_group_reservation.destroy

    redirect_to("/group_reservations", { :notice => "Group reservation deleted successfully."} )
  end
end
