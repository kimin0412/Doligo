package com.dolligo.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.dolligo.dto.Preference;

public interface PreferenceDao extends JpaRepository<Preference, Integer>{
	List<Preference> findByUid(int uid);
}
