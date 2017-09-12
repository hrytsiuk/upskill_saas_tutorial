class ContactsController < ApplicationController
  
  #GET reguest to /contact-us
  #Show new contact form
def new
  @contact = Contact.new
end

#POST reguest to /contact-us
def create
  #Mass assignment of form flieds into Contact object
  @contact = Contact.new(contact_params)
  #Save the Contact object to the database
  if @contact.save
    # Store form fields via paramaters, into variables
    name = params[:contact][:name]
    email = params[:contact][:email]
    body = params[:contact][:comments]
    #Plug variables into Contact Mailer
    #email method and send email
    ContactMailer.contact_email(name, email, body).deliver
    #Store success mesagge in flash hash
    # and redirect to the new action
    flash[:success] = "Message sent."
     redirect_to new_contact_path
  else
    #If Contact object doesn't save,
    # store errors in flash hash,
    # and redirect to the new action
    flash[:danger] = @contact.errors.full_messages.join(", ")
     redirect_to new_contact_path
  end
end

private
# To collect date from form, we need to use
#strong parameters and whitelist the form flieds
  def contact_params
     params.require(:contact).permit(:name, :email, :comments)
  end
end
