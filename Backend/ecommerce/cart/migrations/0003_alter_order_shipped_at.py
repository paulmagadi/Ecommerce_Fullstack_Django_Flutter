# Generated by Django 5.0.6 on 2024-06-05 11:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cart', '0002_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='shipped_at',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]