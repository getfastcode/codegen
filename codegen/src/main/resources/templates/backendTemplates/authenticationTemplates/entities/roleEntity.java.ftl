package [=PackageName].domain.model;

<#if Audit!false>
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import [=PackageName].Audit.AuditedEntity;
</#if>

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Role", schema = "[=SchemaName]")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>

public class RoleEntity<#if Audit!false> extends AuditedEntity<String></#if> implements Serializable {

    private Long id;
    private String displayName;
    private String name;

    @Id
    @Column(name = "Id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "DisplayName", nullable = true, length = 64)
    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Basic
    @Column(name = "Name", nullable = false, length = 32)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RoleEntity)) return false;
        RoleEntity role = (RoleEntity) o;
        return id != null && id.equals(role.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<RolepermissionEntity> getRolepermissionSet() { 
      return rolepermissionSet; 
    } 
 
    public void setRolepermissionSet(Set<RolepermissionEntity> rolepermission) { 
      this.rolepermissionSet = rolepermission; 
    } 
 
    private Set<RolepermissionEntity> rolepermissionSet = new HashSet<RolepermissionEntity>(); 
  
<#if AuthenticationType != "none">

    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<[=AuthenticationTable]Entity> get[=AuthenticationTable]Set() { 
      return [=AuthenticationTable?uncap_first]Set; 
    } 
 
    public void set[=AuthenticationTable]Set(Set<[=AuthenticationTable]Entity> [=AuthenticationTable?uncap_first]) { 
      this.[=AuthenticationTable?uncap_first]Set = [=AuthenticationTable?uncap_first]; 
    } 
 
    private Set<[=AuthenticationTable]Entity> [=AuthenticationTable?uncap_first]Set = new HashSet<[=AuthenticationTable]Entity>(); 
</#if>
    public RoleEntity() {

    }

}
