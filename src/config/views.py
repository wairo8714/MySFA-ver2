from django.views import View
from django.shortcuts import redirect, render
from django.conf import settings

class HomeView(View):
    def get(self, request):
        user_groups = request.user.groups.all() if request.user.is_authenticated else None
        
        if request.user.is_authenticated and user_groups and user_groups.exists():
            return redirect('mysfa:timeline')
        
        return render(request, 'home.html', {'user_groups': user_groups, 'MEDIA_URL': settings.MEDIA_URL})