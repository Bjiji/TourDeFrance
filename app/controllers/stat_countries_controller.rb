class StatCountriesController < ApplicationController
  # GET /stat_countries
  # GET /stat_countries.json
  def index

    if(!params[:nationality1].blank?) then
      @part_nat1 = StatCountry.partNat(params[:nationality1])
      @stat_race_nat1 = StatCountry.statNatRace(params[:nationality1])
      @stat_stage_nat1 = StatCountry.statNatStage(params[:nationality1])
    end
    if(!params[:nationality2].blank?) then
      @part_nat2 = StatCountry.partNat(params[:nationality2])
      @stat_race_nat2 = StatCountry.statNatRace(params[:nationality2])
      @stat_stage_nat2 = StatCountry.statNatStage(params[:nationality2])
    end


    @chart_cnt = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title] = "Nombres Coureurs par pays"
      f.options[:plotOptions] = {
          series: {
              marker: {
                  enabled: false
              }
          }
      }
      f.options[:plotOptions][:line] = {   :cursor => 'pointer',
                                           :point => {:events => {:click => "function() { location.href='http://www.hotmail.com'; }" }}
      }
      f.options[:chart] = {:zoomType => 'x', :defaultSeriesType => "line"}
      f.yAxis({
                   labels: {
                       style: {
                           color: '#89A54E'
                       }
                   },
                   title: {
                       text: 'Nombre de concurrents',
                       style: {
                           color: '#89A54E'
                       }
                   },
                   opposite: false

               })

      if (@part_nat1 != nil) then
        f.xAxis(:tickInterval => 10, :categories => @part_nat1.map{|u| u['year']})
        f.series(:name=>params[:nationality1] + " (nb)", :data=>@part_nat1.map{|u| u['part']})
      end
      if (@part_nat2 != nil) then
        f.xAxis(:tickInterval => 10, :categories => @part_nat2.map{|u| u['year']})
        f.series(:name=>params[:nationality2] + " (nb)", :data=>@part_nat2.map{|u| u['part']})
      end
    end

    @chart_per = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title] = "Pourcentage Coureurs par pays"
      f.options[:chart] = {:zoomType => 'x', :defaultSeriesType => "line"}
      f.options[:plotOptions] = {
          series: {
              marker: {
                  enabled: false
              }
          }
      }
      f.options[:plotOptions][:line] = {   :cursor => 'pointer',
                                           :point => {:events => {:click => "function() { location.href='http://www.hotmail.com'; }" }}
      }
      f.xAxis(:tickInterval => 10, :categories => @part_nat1.map{|u| u['year']})
      f.yAxis({
                  labels: {
                      style: {
                          color: '#89A54E'
                      }
                  },
                  title: {
                      text: 'Pourcentage de concurrents',
                      style: {
                          color: '#89A54E'
                      }
                  },
                  opposite: false

              })

      if (@part_nat1 != nil) then
        #f.xAxis(:tickInterval => 10, :categories => @part_nat1.map{|u| u['year']})
        f.series(:name=>params[:nationality1] + " (nb)", :data=>@part_nat1.map{|u| (u['part'] * 100 / u['tot'])})
      end
      if (@part_nat2 != nil) then
        #f.xAxis(:tickInterval => 10, :categories => @part_nat2.map{|u| u['year']})
        f.series(:name=>params[:nationality2] + " (nb)", :data=>@part_nat2.map{|u| (u['part'] * 100 / u['tot'])})
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stat_countries }
    end
  end


end
