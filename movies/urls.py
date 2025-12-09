from django.urls import path
from .views import landig_page, movie_detail

urlpatterns = [
    path('', landig_page, name='landing_page'),
    path("movie/<int:movie_id>/", movie_detail, name="movie_detail")
]