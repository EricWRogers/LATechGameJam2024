using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using SuperPupSystems.Helper;

public class WinMenu : MonoBehaviour
{
    public bool didSurviveTime = false;

    public Health playerHealth;

    public GameObject winSection;

    public GameObject healthBar;
    public GameObject PowerUpSection;
    public GameObject TMSection;

    void Start()
    {
        winSection.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if(didSurviveTime && playerHealth.currentHealth != 0)
        {
            Win();
        }   
    }

    public void TimeToSurvive(bool timeOver)
    {
        if(timeOver)
        {
            didSurviveTime = true;
        }
    }

    public void Win()
    {
        Debug.Log("You have WON!");
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        winSection.SetActive(true);
        healthBar.SetActive(false);
        PowerUpSection.SetActive(false);
        TMSection.SetActive(false);
        Time.timeScale = 1.0f;
    }

    public void Retry()
    {
        //SceneManager.LoadSceneAysnc(1);
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().buildIndex);
    }

    public void LoadMenu()
    {
        Debug.Log("Loading Main Menu");
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync("MainMenu");
    }

    public void QuitGame()
    {
        #if(UNITY_EDITOR)
        Debug.Log("Quiting Play Mode");
        EditorApplication.ExitPlaymode();
        #else
        Debug.Log("Quitting Build");
        Application.Quit();
        #endif
    }
}
