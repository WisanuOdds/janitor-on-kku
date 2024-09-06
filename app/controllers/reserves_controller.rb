class ReservesController < ApplicationController
  before_action :isLogin
  before_action :set_reserf, only: %i[ show edit update destroy ]
  attr_reader :selected_date

  # GET /reserves or /reserves.json
  def index
    @reserves = Reserve.all
    @user = Page.get_user_form_session(session)
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.today
    dateNext3Month = Date.today + 3.month
    @alert_message = ""
    @booking_data = Reserve.where(date: @selected_date).order(:start_timer)

    if @selected_date > dateNext3Month
      @selected_date = dateNext3Month
      @alert_message = "Maximum date is 3 months from now"
    elsif @selected_date < Date.today
      @selected_date = Date.today
      @alert_message = "You can't select the past date"
    end

    @days_in_month = Date.new(@selected_date.year, @selected_date.month, -1).day
    @start_of_month = @selected_date.beginning_of_month.wday

    @rooms = [
      { id: 1, room_name: "Meeting 1", room_address: "Binary Base", seat: 3, room_description: "Small meeting room" },
      { id: 2, room_name: "Meeting 2", room_address: "Binary Base", seat: 6, room_description: "Medium meeting room" },
      { id: 3, room_name: "Territory 1", room_address: "Binary Base", seat: 5, room_description: "Large meeting room" },
      { id: 4, room_name: "Territory 2", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
      { id: 5, room_name: "Territory 3", room_address: "Binary Base", seat: 5, room_description: "Extra large meeting room" },
      { id: 6, room_name: "Global", room_address: "Binary Base", seat: 30, room_description: "Extra large meeting room" },
      { id: 7, room_name: "All Nighter 1", room_address: "Binary Base", seat: 36, room_description: "LeSSex Area" },
      { id: 8, room_name: "All Nighter 2", room_address: "Binary Base", seat: 32, room_description: "LeSSex Area" },
    ]
  end

  # PATCH /reserves/update_selected_date
  def update_selected_date
    if params[:date].present?
      @selected_date = Date.parse(params[:date])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("calendar", partial: "calendar", locals: { selected_date: @selected_date, days_in_month: Date.new(@selected_date.year, @selected_date.month, -1).day, rooms: @rooms })
        end
        format.html { redirect_to reserves_path(date: @selected_date) }
      end
    else
      head :unprocessable_entity
    end
  rescue ArgumentError => error.message
    Rails.logger.error "Invalid date format: #{params[:date]}"
    head :unprocessable_entity
  end

  # GET /reserves/1 or /reserves/1.json
  def show
  end

  # GET /reserves/new
  def new
    @reserf = Reserve.new
  end

  # GET /reserves/1/edit
  def edit
  end

  # POST /reserves or /reserves.json
  def create
    @reserf = Reserve.new(reserf_params)

    respond_to do |format|
      if @reserf.save
        format.html { redirect_to reserf_url(@reserf), notice: "Reserve was successfully created." }
        format.json { render :show, status: :created, location: @reserf }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reserf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reserves/1 or /reserves/1.json
  def update
    respond_to do |format|
      if @reserf.update(reserf_params)
        format.html { redirect_to reserf_url(@reserf), notice: "Reserve was successfully updated." }
        format.json { render :show, status: :ok, location: @reserf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reserf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reserves/1 or /reserves/1.json
  def destroy
    @reserf.destroy!

    respond_to do |format|
      format.html { redirect_to reserves_url, notice: "Reserve was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reserf
    @reserf = Reserve.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
    def reserf_params
      params.require(:reserve).permit(:date, :start_timer, :end_timer, :note)
    end
end