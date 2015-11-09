# Copyright 2012 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Copyright 2012 Nebula, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from django.conf.urls import include  # noqa
from django.conf.urls import patterns
from django.conf.urls import url

from openstack_dashboard.dashboards.project.images.images \
    import urls as image_urls
from openstack_dashboard.dashboards.project.images.snapshots \
    import urls as snapshot_urls
from openstack_dashboard.dashboards.project.images import views
from openstack_dashboard.dashboards.project.images.market \
    import views as market_views
from openstack_dashboard.dashboards.project.images.snapshots \
    import views as snapshot_views

urlpatterns = patterns('',
    url(r'^$', views.IndexView.as_view(), name='index'),
    url(r'^market$', market_views.IndexView.as_view(), name='market'),
    url(r'^publish$', snapshot_views.PublishView.as_view(), name='publish'),
    url(r'', include(image_urls, namespace='images')),
    url(r'', include(snapshot_urls, namespace='snapshots')),
)
