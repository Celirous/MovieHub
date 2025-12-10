from django.contrib import admin
from .models import CustomUser, UserList, ListItem
from django.contrib.auth.admin import UserAdmin

admin.site.register(CustomUser, UserAdmin)

class ListItemsInline(admin.TabularInline):
    model = ListItem

@admin.register(UserList)
class UserListAdmin(admin.ModelAdmin):
    inlines = [ListItemsInline]

@admin.register(ListItem)
class ListItemAdmin(admin.ModelAdmin):
    pass
