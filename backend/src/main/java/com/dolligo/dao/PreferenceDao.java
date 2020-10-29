package com.dolligo.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.dolligo.dto.Preference;

public interface PreferenceDao extends JpaRepository<Preference, Integer>{
}
