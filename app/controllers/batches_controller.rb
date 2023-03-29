class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update, :create, :destroy]
  before_action :require_admin, only: [ :show, :edit, :update, :create, :destroy]

  def index 
    @batches = Batch.order(start_date: :asc)
  end 

  def new 

  end 

  def show 
    @batch = Batch.find(params[:id])
    @students = @batch.users
  end 

  def create  

  end 

  def edit  

  end 

  def update 

  end 

  def destroy 

  end 

  def pdf 
    @batch = Batch.find(params[:id])

    html = render_to_string(inline: render_table)

    kit = PDFKit.new(html)
    file = kit.to_file('batch_table.pdf')

    send_file(
      file.path,
      filename: 'batch_table.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end 

  private  

  def render_table
   
    <<-HTML
    <h1><%= @batch.name %></h1>
    <table style="width: 100%; font-size: 12pt; border-collapse: collapse; font-family: Arial, sans-serif;">
    <thead>
        <tr>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Name</th>
            <th style="padding: 8px 10px; text-align: left; border: 1px solid #000; background-color: #e0e0e0; font-weight: bold;">Email</th>
            <!-- Add other column headers here -->
        </tr>
    </thead>
    <tbody>
    <% @batch.users.each do |user| %>
            <tr style="background-color: <%= cycle('#ccffd9', '#e6ffec') %>;">
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= user.first_name %></td>
                <td style="padding: 8px 10px; text-align: left; border: 1px solid #000;"><%= user.email %></td>
                <!-- Add other columns here -->
            </tr>
      <% end %>
    </tbody>
</table>
    HTML
     end 
        




end
