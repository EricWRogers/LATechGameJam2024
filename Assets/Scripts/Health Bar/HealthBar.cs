using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using SuperPupSystems.Helper;
using TMPro;

public class HealthBar : MonoBehaviour
{
    public Slider slider;
    public Health health;
    public TMP_Text healthText;
    
    public void Start()
    {
        slider.maxValue = health.maxHealth;
    }

    public void SetHealth()
    {
        slider.value = health.currentHealth;
    }

    public void TextOfPlayersHealth()
    {
        healthText.text = "" + health.currentHealth;
    }
}
