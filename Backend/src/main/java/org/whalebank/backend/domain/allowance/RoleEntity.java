package org.whalebank.backend.domain.allowance;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.UserEntity;

@Entity
@Table(name="we_role")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class RoleEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private int roleId;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name="user_id")
  private UserEntity user;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "group_id")
  private GroupEntity userGroup;

  @Enumerated(value = EnumType.STRING)
  private Role role;

  private int accountId; // 용돈을 줄 계좌 고유 번호

  private String accountNum; // 용돈을 줄 계좌 번호

  private String groupNickname; // default: 이름?

  public static RoleEntity of(UserEntity user, String groupNickname, int accountId, String accountNum,
      GroupEntity group) {
    RoleEntity entity = RoleEntity.builder()
        .user(user)
        .userGroup(group)
        .role(user.getRole())
        .accountId(accountId)
        .accountNum(accountNum)
        .groupNickname(groupNickname)
        .build();
    group.addRole(entity);
    return entity;
  }

  public String getRole() {
    return role.toString();
  }

  public void updateNickname(String newNickname) {
    this.groupNickname = newNickname;
  }

}
