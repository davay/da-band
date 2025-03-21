from django.http import HttpResponse
from django.shortcuts import render
import os

def download_page(request):
    return render(request, 'ml_model/download_model.html')

def download_model(request):
    # Path to the saved model file
    file_path = os.path.join(os.path.dirname(__file__), 'models', 'catboost.pkl')

    # Serve the file as a response
    if os.path.exists(file_path):
        with open(file_path, 'rb') as f:
            response = HttpResponse(f.read(), content_type='application/octet-stream')
            response['Content-Disposition'] = 'attachment; filename="catboost.pkl"'
            return response
    else:
        return HttpResponse('Model file not found.', status=404)
