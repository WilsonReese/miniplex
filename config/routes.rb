Rails.application.routes.draw do

  # HOME
  get("/", { :controller => "movies", :action => "index" })

  # Routes for the Ticket request resource:

  # CREATE
  post("/insert_ticket_request", { :controller => "ticket_requests", :action => "create" })
          
  # READ
  get("/ticket_requests", { :controller => "ticket_requests", :action => "index" })
  
  get("/ticket_requests/:path_id", { :controller => "ticket_requests", :action => "show" })
  
  # UPDATE
  
  post("/modify_ticket_request/:path_id", { :controller => "ticket_requests", :action => "update" })
  
  # DELETE
  get("/delete_ticket_request/:path_id", { :controller => "ticket_requests", :action => "destroy" })

  #------------------------------

  # Routes for the Group reservation resource:

  # CREATE
  post("/insert_group_reservation", { :controller => "group_reservations", :action => "create" })
          
  # READ
  get("/group_reservations", { :controller => "group_reservations", :action => "index" })
  
  get("/group_reservations/:path_id", { :controller => "group_reservations", :action => "show" })
  
  # UPDATE
  
  post("/modify_group_reservation/:path_id", { :controller => "group_reservations", :action => "update" })
  
  # DELETE
  get("/delete_group_reservation/:path_id", { :controller => "group_reservations", :action => "destroy" })

  #------------------------------

  # Routes for the Location resource:

  # CREATE
  post("/insert_location", { :controller => "locations", :action => "create" })
          
  # READ
  get("/locations", { :controller => "locations", :action => "index" })
  
  get("/locations/:path_id", { :controller => "locations", :action => "show" })
  
  # UPDATE
  
  post("/modify_location/:path_id", { :controller => "locations", :action => "update" })
  
  # DELETE
  get("/delete_location/:path_id", { :controller => "locations", :action => "destroy" })

  #------------------------------

  # Routes for the Movie resource:

  # CREATE
  post("/insert_movie", { :controller => "movies", :action => "create" })
          
  # READ
  get("/movies", { :controller => "movies", :action => "index" })
  
  get("/movies/:path_id", { :controller => "movies", :action => "show" })
  
  # UPDATE
  
  post("/modify_movie/:path_id", { :controller => "movies", :action => "update" })
  
  # DELETE
  get("/delete_movie/:path_id", { :controller => "movies", :action => "destroy" })

  #------------------------------

  # Routes for the Theater resource:

  # CREATE
  post("/insert_theater", { :controller => "theaters", :action => "create" })
          
  # READ
  get("/theaters", { :controller => "theaters", :action => "index" })
  
  get("/theaters/:path_id", { :controller => "theaters", :action => "show" })
  
  # UPDATE
  
  post("/modify_theater/:path_id", { :controller => "theaters", :action => "update" })
  
  # DELETE
  get("/delete_theater/:path_id", { :controller => "theaters", :action => "destroy" })

  #------------------------------

  # Routes for the User account:

  # SIGN UP FORM
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })        
  # CREATE RECORD
  post("/insert_user", { :controller => "user_authentication", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })       
  # UPDATE RECORD
  post("/modify_user", { :controller => "user_authentication", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })
             
  #------------------------------

end
