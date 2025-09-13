from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model

class MySFABasicTest(TestCase):
    
    def setUp(self):
        self.client = Client()
        User = get_user_model()
        self.user = User.objects.create_user(
            username='testuser',
            custom_user_id='TEST001',
            email='test@example.com',
            password='testpass123',
            question='テスト質問',
            answer='テスト回答'
        )
        
    def test_home_page_loads(self):
        """ホームページが正常に読み込まれるかテスト"""
        response = self.client.get(reverse('home'))
        self.assertEqual(response.status_code, 200)
        
    def test_timeline_page_requires_login(self):
        """タイムライン表示にはログインが必要かテスト"""
        response = self.client.get(reverse('mysfa:timeline'))
        self.assertEqual(response.status_code, 302)
        
    def test_timeline_page_with_login(self):
        """ログイン後のタイムライン表示が正常に動作するかテスト"""
        self.client.login(username='testuser', password='testpass123')
        response = self.client.get(reverse('mysfa:timeline'))
        self.assertEqual(response.status_code, 200)
