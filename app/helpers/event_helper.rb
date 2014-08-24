module EventHelper
  include HtmlBuilder

  def event_table_row(event)
    markup(:tr) do |m|
      unless instance_variable_get(:@user)
        m.td do
          m << link_to(event.user.name, [ :admin, event.user, :events ])
        end
      end
      m.td event.description
      m.td do
        m.text event.occurred_at.strftime('%Y/%m/%d %H:%M:%S')
      end
    end
  end
end
