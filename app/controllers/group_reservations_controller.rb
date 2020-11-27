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
    res_target_date = params.fetch("query_reservation_date").to_date
    res_target_time = params.fetch("query_reservation_time").to_time
    res_target_size = params.fetch("query_number_of_tickets").to_i

    # the_group_reservation.reservation_date = params.fetch("query_reservation_date")
    # the_group_reservation.reservation_time = params.fetch("query_reservation_time")
    # the_group_reservation.number_of_tickets = params.fetch("query_number_of_tickets")
    
    # movie needs to come from the previous click
    res_target_movie_id = params.fetch("query_movie_id")
    
    #duration = movie.duration + theater.turnover_time
    # the_group_reservation.reservation_duration = params.fetch("query_reservation_duration")

    # movie_duration = the_group_reservation.movie.duration
    movie_duration = Movie.where({ :id => res_target_movie_id }).first.duration

    # theater comes from availability
    # the_group_reservation.theater_id = params.fetch("query_theater_id")

    d = res_target_date
    t = res_target_time
    new_reservation_datetime = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)
    new_reservation_movie_end = new_reservation_datetime + movie_duration.minutes
    current_datetime = DateTime.now
    #need to remove this
    new_res_duration = movie_duration
    new_res_theater = 0
    error_message = ""
    the_group_reservation.number_of_tickets = res_target_size
    the_group_reservation.reservation_date = res_target_date
    the_group_reservation.reservation_duration = new_res_duration
    the_group_reservation.reservation_end_time = res_target_time + new_res_duration.minutes
    the_group_reservation.reservation_time = res_target_time

    if new_reservation_datetime > current_datetime # if reservation is in the future
      
      a_theater_position = 0 # starting array position
      while the_group_reservation.reservation_status == "requested" # reservation is not available
        if Theater.all.at(a_theater_position) == nil # if we have already checked all the theaters
          the_group_reservation.reservation_status = "failed" # break while loop
        else # we have not checked all theaters and need to go through it again
          a_theater = Theater.all.at(a_theater_position) # get a theater in array of theaters

          if res_target_size <= a_theater.seats_in_theater # if theater is big enough
            # check if there are reservations on a day
            if a_theater.group_reservations.where({ :reservation_date => res_target_date }).count == 0 # no reservations
              the_group_reservation.reservation_status = "available"
              new_res_duration = movie_duration + a_theater.turnover_time
              new_res_theater = a_theater.id
              
            elsif a_theater.group_reservations.where({ :reservation_date => res_target_date }).count > 0
              the_group_reservation.reservation_duration = movie_duration + a_theater.turnover_time
              a_theater.group_reservations.where({ :reservation_date => res_target_date }).each do |a_reservation|
                if the_group_reservation.overlaps?(a_reservation) # if it overlaps
                  error_message = error_message + "[The time you selected] is unavailable in all theaters. "
                  
                  # need to make this in conjunction with theater not big enough
                  # add 1 to "theaters_unavailable" 
                  # if theaters_unavailable + theaters_too_small == count of theaters && theaters_unavailable != count of theaters
                  #   theaters_too_small error message needs to be displayed and
                  # else # all theaters were big enough
                  #   "All theaters are unavailable at TIME on DATE." and suggest new times from all theaters
                  # then make it redirect to the same reservation page, with an error message and a slightly earlier and later start times suggestions
                  # when suggesting new times, we only want to look in theaters that are big enough
                  # make a suggested start time that equal target_time, it should automatically update target_end_time (start time+ duration)
                  # check each minute earlier and later in a theater if it overlaps to get earlier time and later time
                  

                else # does not overlap
                  the_group_reservation.reservation_status = "available"
                  new_res_duration = movie_duration + a_theater.turnover_time
                  new_res_theater = a_theater.id
                end 
              end
            end

          else # theater is not big enough
            # check next theater
            error_message = "There are no theaters available that seat " + res_target_size.to_s + " people. "
            
            # add 1 to "theaters_too_small"
            # need to count theaters that are not big enough to fit target_size => if there are any theaters that are not big enough, a different error message needs to be displayed => "The theaters large enough to seat X people are unavailable at TIME on DATE."

            # need to move onto the next theater - add 1 to theater_position
            # but if there are no theaters left to check, the reservation fails => count array of theaters 
            
          end
        end

        a_theater_position += 1 #move to next position in array

      end
    else
      the_group_reservation.reservation_status = "failed"
      error_message = error_message + "Reservation must be in the future. "
    end

    if the_group_reservation.reservation_status == "available"
      the_group_reservation.number_of_tickets = res_target_size
      the_group_reservation.reservation_date = res_target_date
      the_group_reservation.reservation_duration = new_res_duration
      the_group_reservation.reservation_end_time = res_target_time + new_res_duration.minutes

      the_group_reservation.reservation_time = res_target_time
      the_group_reservation.theater_id = new_res_theater
      the_group_reservation.movie_id = res_target_movie_id
      
      if the_group_reservation.valid?
        the_group_reservation.save
        redirect_to("/group_reservations", { :notice => "Group reservation created successfully." })
      else
        redirect_to("/group_reservations", { :notice => "Group reservation failed to create successfully." })
      end
    elsif the_group_reservation.reservation_status == "failed"
      redirect_to("/group_reservations", { :alert => error_message })
    else
      redirect_to("/group_reservations", { :notice => "I messed something up" })
    end
    
    
    # if new_reservation_datetime > current_datetime
      
    #   #need to get the closest reservations to current time
    #   # all of the reservations on a day in one theater, get whose end time is closest to start time and one whose start time is closest to end time

    #   Theater.all.each do |a_theater|
    #     if res_target_size <= a_theater.seats_in_theater

    #       if a_theater.group_reservations.first == nil
    #         new_res_duration = movie_duration + a_theater.turnover_time
    #         new_res_theater = a_theater.id

    #         the_group_reservation.reservation_duration = new_res_duration
    #         the_group_reservation.theater_id = new_res_theater
    #         the_group_reservation.reservation_date = res_target_date
    #         the_group_reservation.reservation_time = res_target_time
    #         the_group_reservation.number_of_tickets = res_target_size
    #       # if # only one reservation
    #       else
    #         #need conditional for if there are no reservations
    #         just_before = Time.new(d.year, d.month, d.day, 0, 0, 0) # change this to earliest reservation time
    #         just_after = Time.new(d.year, d.month, d.day, 23, 59, 59) #last reservation time

    #         a_theater.group_reservations.where({ :reservation_date => res_target_date }).each do |a_reservation|
    #           a_res_diff = res_target_time.to_i - a_reservation.reservation_time.to_i
    #           old_res_diff_before = res_target_time.to_i - just_before.to_i
    #           if a_res_diff < old_res_diff_before && a_res_diff > 0
    #             just_before = a_reservation.reservation_time
    #           end

    #           old_res_diff_after = res_target_time.to_i - just_after.to_i
    #           if a_res_diff > old_res_diff_after && a_res_diff < 0
    #             just_after = a_reservation.reservation_time
    #           end 
    #           #now i have just before and just after start times on the right dates for each theater
    #           # check target start time against just_before and just_before + duration
    #           # check target start time against just_after and just_after + duration
    #           end_time_before = just_before + a_reservation.reservation_duration.minutes
    #           end_time_after = just_after + a_reservation.reservation_duration.minutes

    #           new_reservation_end = new_reservation_movie_end + a_reservation.theater.turnover_time.minutes

    #           if ((res_target_time >= just_before) && (res_target_time <= end_time_before)) || ((new_reservation_end >= just_after) && (new_reservation_end <= end_time_after))
    #           else
    #             new_res_duration = movie_duration + a_theater.turnover_time
    #             new_res_theater = a_theater.id
    #           end
    #         end
    #       end
          
    #       the_group_reservation.reservation_duration = new_res_duration
    #       the_group_reservation.theater_id = new_res_theater
    #       the_group_reservation.reservation_date = res_target_date
    #       the_group_reservation.reservation_time = res_target_time
    #       the_group_reservation.number_of_tickets = res_target_size
    #     end
    #   end
    


    # else
    #   redirect_to("/group_reservations", { :notice => "Group reservation failed to create successfully." })
    # end

    # # need custom validation for if theater is available is open
    # # if theater is not open, we need to suggest new times, -- redirect to a new page? send an alert?
    # # if reservation is valid, reservation status becomes available (calculates reservation duration, blocks off theater, sends tickets)
    # if the_group_reservation.valid?
    #   the_group_reservation.save
    #   redirect_to("/group_reservations", { :notice => "Group reservation created successfully." })
    # else
    #   redirect_to("/group_reservations", { :notice => "Group reservation failed to create successfully." })
    # end
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
