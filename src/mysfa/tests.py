from django.contrib.auth import get_user_model
from django.test import Client, TestCase
from django.urls import reverse

from .models import Group, Post

User = get_user_model()


class MySFATestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username="testuser", email="test@example.com", password="testpass123"
        )
        self.client.login(username="testuser", password="testpass123")

    def test_home_page_loads(self):
        """ホームページが正常に読み込まれることをテスト"""
        response = self.client.get(reverse("home"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "MySFA")

    def test_user_registration(self):
        """ユーザー登録が正常に動作することをテスト"""
        response = self.client.post(
            reverse("signup"),
            {
                "username": "newuser",
                "email": "newuser@example.com",
                "password1": "newpass123",
                "password2": "newpass123",
            },
        )
        self.assertEqual(response.status_code, 302)  # リダイレクト
        self.assertTrue(User.objects.filter(username="newuser").exists())

    def test_post_creation(self):
        """投稿作成が正常に動作することをテスト"""
        response = self.client.post(
            reverse("create_post"),
            {"title": "Test Post", "content": "This is a test post"},
        )
        self.assertEqual(response.status_code, 302)  # リダイレクト
        self.assertTrue(Post.objects.filter(title="Test Post").exists())

    def test_group_creation(self):
        """グループ作成が正常に動作することをテスト"""
        response = self.client.post(
            reverse("create_group"),
            {"name": "Test Group", "description": "This is a test group"},
        )
        self.assertEqual(response.status_code, 302)  # リダイレクト
        self.assertTrue(Group.objects.filter(name="Test Group").exists())
