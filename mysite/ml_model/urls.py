from django.urls import path
from . import views

urlpatterns = [
    path('page/', views.download_page, name='download_page'),
    path('download/', views.download_model, name='download_model'),
]
