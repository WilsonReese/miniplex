class TicketRequestsController < ApplicationController
  def index
    matching_ticket_requests = TicketRequest.all

    @list_of_ticket_requests = matching_ticket_requests.order({ :created_at => :desc })

    render({ :template => "ticket_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_ticket_requests = TicketRequest.where({ :id => the_id })

    @the_ticket_request = matching_ticket_requests.at(0)

    render({ :template => "ticket_requests/show.html.erb" })
  end

  def create
    the_ticket_request = TicketRequest.new

    #comes from params
    the_ticket_request.user_id = params.fetch("query_user_id")
    the_ticket_request.group_id = params.fetch("query_group_id")
    the_group_reservation = GroupReservation.where({ :id => the_ticket_request.group_id }).first

    #first should default to
    the_ticket_request.ticket_status = params.fetch("query_ticket_status")
    the_ticket_request.ticket = params.fetch("query_ticket")

    # to get it to create the first ticket -> user_id is current user, group_id is from the reservation, status is assigned, and ticket is produced
    # tickets_made = 0
    # 
    # while tickets_made < the_group_reservation.

    if the_ticket_request.valid?
      the_ticket_request.save
      redirect_to("/ticket_requests", { :notice => "Ticket request created successfully." })
    else
      redirect_to("/ticket_requests", { :notice => "Ticket request failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_ticket_request = TicketRequest.where({ :id => the_id }).at(0)

    the_ticket_request.user_id = params.fetch("query_user_id")
    the_ticket_request.group_id = params.fetch("query_group_id")
    the_ticket_request.ticket_status = params.fetch("query_ticket_status")
    the_ticket_request.ticket = params.fetch("query_ticket")

    if the_ticket_request.valid?
      the_ticket_request.save
      redirect_to("/ticket_requests/#{the_ticket_request.id}", { :notice => "Ticket request updated successfully."} )
    else
      redirect_to("/ticket_requests/#{the_ticket_request.id}", { :alert => "Ticket request failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_ticket_request = TicketRequest.where({ :id => the_id }).at(0)

    the_ticket_request.destroy

    redirect_to("/ticket_requests", { :notice => "Ticket request deleted successfully."} )
  end
end
