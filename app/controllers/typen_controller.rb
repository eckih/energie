# encoding: UTF-8
class TypenController < ApplicationController
  # GET /typen
  # GET /typen.json
  def index
    @typen = Typ.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @typen }
    end
  end

  # GET /typen/1
  # GET /typen/1.json
  def show
    @typ = Typ.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @typ }
    end
  end

  # GET /typen/new
  # GET /typen/new.json
  def new
    @typ = Typ.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @typ }
    end
  end

  # GET /typen/1/edit
  def edit
    @typ = Typ.find(params[:id])
  end

  # POST /typen
  # POST /typen.json
  def create
    @typ = Typ.new(params[:typ])

    respond_to do |format|
      if @typ.save
        format.html { redirect_to @typ, notice: 'Typ was successfully created.' }
        format.json { render json: @typ, status: :created, location: @typ }
      else
        format.html { render action: "new" }
        format.json { render json: @typ.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /typen/1
  # PUT /typen/1.json
  def update
    @typ = Typ.find(params[:id])

    respond_to do |format|
      if @typ.update_attributes(params[:typ])
        format.html { redirect_to @typ, notice: 'Typ was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @typ.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /typen/1
  # DELETE /typen/1.json
  def destroy
    @typ = Typ.find(params[:id])
    @typ.destroy

    respond_to do |format|
      format.html { redirect_to typen_url }
      format.json { head :no_content }
    end
  end
end
