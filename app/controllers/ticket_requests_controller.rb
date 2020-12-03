class TicketRequestsController < ApplicationController
  def index
    matching_ticket_requests = TicketRequest.all

    @list_of_ticket_requests = matching_ticket_requests.order({ :created_at => :desc })
    
    # the_group_reservation = GroupReservation.where({ :id => the_ticket_request.group_id }).first
    # @user_group_tickets = @list_of_ticket_requests.where({ :group_id => the_group_reservation.id })

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
    the_ticket_request.ticket_status = "assigned"

    #need to get ticket from API
    
    # to get it to create the first ticket -> user_id is current user, group_id is from the reservation, status is assigned, and ticket is produced
    the_ticket_request.ticket = "QR CODE FOR FIRST TICKET"
    if the_group_reservation == nil
      redirect_to("/", { :alert => "Tickets failed to create successfully. Your session expired." })
    else
      if the_ticket_request.valid?
        the_ticket_request.save
      else
        redirect_to("/ticket_requests", { :notice => "Ticket FIRST request failed to create successfully." })
      end
      tickets_made = 1
      while tickets_made < the_group_reservation.number_of_tickets
        another_ticket_request = TicketRequest.new
        another_ticket_request.group_id = params.fetch("query_group_id")
        another_ticket_request.ticket_status = "unassigned"
        another_ticket_request.ticket = "QR CODE FOR TICKET #{tickets_made + 1}."
        if another_ticket_request.valid?
          another_ticket_request.save
        else
          redirect_to("/ticket_requests", { :notice => "Ticket request #{tickets_made + 1} failed to create successfully." })
        end
        tickets_made += 1
      end
      the_group_reservation.reservation_status = "confirmed"
      the_group_reservation.save
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :notice => "We're happy to have you! Here are your tickets." })
    end 
  end

  def update
    the_id = params.fetch("path_id")
    the_ticket_request = TicketRequest.where({ :id => the_id }).at(0)
    the_group_reservation = GroupReservation.where({ :id => the_ticket_request.group_id }).first
    query_email = params.fetch("query_user_email")

    if User.exists?(:email => query_email)
      the_ticket_request.user_id = User.where({ :email => query_email }).first.id
      the_ticket_request.ticket_status = "assigned"
      if the_ticket_request.valid?
        the_ticket_request.save
        redirect_to("/group_reservations/#{the_group_reservation.id}", { :notice => "Ticket assigned to #{query_email}."} )
      else
        redirect_to("/group_reservations/#{the_group_reservation.id}", { :alert => "Ticket request failed to update successfully." })
      end
    else
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :alert => "There is no user with the email: #{query_email}" })
    end
    
    # the_ticket_request.user_id = params.fetch("query_user_id")
    # the_ticket_request.group_id = params.fetch("query_group_id")
    # the_ticket_request.ticket_status = params.fetch("query_ticket_status")
    # the_ticket_request.ticket = params.fetch("query_ticket")

    # if the_ticket_request.valid?
    #   the_ticket_request.save
    #   redirect_to("/ticket_requests/#{the_ticket_request.id}", { :notice => "Ticket request updated successfully."} )
    # else
    #   redirect_to("/ticket_requests/#{the_ticket_request.id}", { :alert => "Ticket request failed to update successfully." })
    # end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_ticket_request = TicketRequest.where({ :id => the_id }).at(0)

    the_ticket_request.destroy

    redirect_to("/ticket_requests", { :notice => "Ticket request deleted successfully."} )
  end
end
