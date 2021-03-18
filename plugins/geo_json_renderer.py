from datasette import hookimpl
from datasette.utils.asgi import Response
import geojson
from plpygis import Geometry

# https://docs.datasette.io/en/stable/plugin_hooks.html#register-output-renderer-datasette

# can_render_demo is a Python function (or async def function)
# which acepts the same arguments as render_demo but just returns
# True or False. It lets Datasette know if the current SQL query
# can be represented by the plugin - and hence influnce if a link
# to this output format is displayed in the user interface. If you
# omit the "can_render" key from the dictionary every query will be
# treated as being supported by the plugin.
def can_render_geo_json():
    True

async def render_geo_json(
    datasette, request, sql, columns, rows, database, table, query_name, view_name, data
):
    result = await datasette.execute(database, sql)

    # create a new list which will store the single GeoJSON features
    feature_list = list()

    for row in result:
        # Is this a blatant Point object?
        if hasattr(row, 'longitude') and hasattr(row, 'latitude'):
            # https://geojson.org/geojson-spec.html#id2
            point = geojson.Point((row['longitude'], row['latitude']))
            # create a geojson feature
            feature = geojson.Feature(geometry=point, properties=dict(row))
            # append the current feature to the list of all features
            feature_list.append(feature)
        
        # Otherwise, does this have a "the_geom" object, which was used in the old Carto database, which encodes geographical data as a string in the "well-known binary" format?
        elif hasattr(row, 'the_geom'):
            feature = Geometry(row['the_geom'])
            feature_list.append(feature)
          
        else:
            # TODO: do we need to have error handling here?
            pass

    feature_collection = geojson.FeatureCollection(feature_list)
    body = geojson.dumps(feature_collection)
    content_type = "application/json; charset=utf-8"
    headers = {}
    status_code = 200 # add query / error handling!

    # Note: currently max result size is 1000 (can increase via settings.json)
    #       OR look at using link setup for paging result sets
    #       if required as outlined in datasette docs
    # if next_url:
    #     headers["link"] = f'<{next_url}>; rel="next"'

    return Response(
        body=body, status=status_code, headers=headers, content_type=content_type
    )


@hookimpl
def register_output_renderer(datasette):
    return {
        "extension": "geojson",
        "render": render_geo_json,
        "can_render": can_render_geo_json
    }