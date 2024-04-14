using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using SuperPupSystems.Helper;

public class LoseMenu : MonoBehaviour
{
    public bool isPlayerDead = false;
    public bool didLose = false;

    public Health playerHealth;

    public GameObject loseSection;

    public GameObject healthBar;
    public GameObject PowerUpSection;
    public GameObject TMSection;
    public GameObject reticle;

    void Start()
    {
        loseSection.SetActive(false);
    }

    public void Lose()
    {
        Debug.Log("You have WON!");
        didLose = true;
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        loseSection.SetActive(true);
        healthBar.SetActive(false);
        PowerUpSection.SetActive(false);
        TMSection.SetActive(false);
        reticle.SetActive(false);
        Time.timeScale = 0.0f;
    }

    public void Retry()
    {
        Time.timeScale = 1.0f;
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
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
