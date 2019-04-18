package [=PackageName].domain.[=ClassName];

import java.util.Iterator;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
</#list>

import [=PackageName].domain.IRepository.I[=ClassName]Repository;
import com.querydsl.core.types.Predicate;

@Repository
public class [=ClassName]Manager implements I[=ClassName]Manager {

    @Autowired
    I[=ClassName]Repository  _[=InstanceName]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Autowired
	I[=relationValue.eName]Repository  _[=relationValue.eName?lower_case]Repository;
    </#if>
    </#list>
    
	@Transactional
	public [=EntityClassName] Create([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	@Transactional
	public void Delete([=EntityClassName] [=InstanceName]) {

		_[=InstanceName]Repository.delete([=InstanceName]);	
	}

	@Transactional
	public [=EntityClassName] Update([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	@Transactional
	public [=EntityClassName] FindById(Long id) {

		return _[=InstanceName]Repository.findById(id.longValue());
	}

	@Transactional
	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}

	@Transactional
	public [=EntityClassName] FindByName(String name) {

		return _[=InstanceName]Repository.findByName(name);
	}
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
  @Transactional
	public void Add[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {

		[=InstanceName].set[=relationValue.eName]([=relationValue.eName?lower_case]);
		_[=InstanceName]Repository.save([=InstanceName]);
		_[=relationValue.eName?lower_case]Repository.save([=relationValue.eName?lower_case]);
	}

	@Transactional
	public void Remove[=relationValue.eName]([=EntityClassName] [=InstanceName]) {
	
		[=InstanceName].set[=relationValue.eName](null);
		_[=InstanceName]Repository.save([=InstanceName]);
	}

	@Transactional
	public [=relationValue.eName]Entity Get[=relationValue.eName](Long [=InstanceName]Id) {
		
		[=EntityClassName] entity = _[=InstanceName]Repository.findById([=InstanceName]Id.longValue());
		return entity.get[=relationValue.eName]();
	}
  <#elseif relationValue.relation == "ManyToMany">
   <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_before("-") == relationValue.eName>
    //[=relationValue.eName]
    @Transactional
	public Boolean Add[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {
		
		Set<[=EntityClassName]> entitySet = [=relationValue.eName?lower_case].get[=ClassName]s();

		if (!entitySet.contains([=InstanceName])) {
			[=relationValue.eName?lower_case].add[=ClassName]([=InstanceName]);
		} else {
			return false;
		//	throw new EntityExistsException("The [=ClassName?lower_case] already has the [=relationValue.eName?lower_case]");
		}
		_[=relationValue.eName?lower_case]Repository.save([=relationValue.eName?lower_case]);
		return true;
	}

	@Transactional
	public void Remove[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {

		[=relationValue.eName?lower_case].remove[=ClassName]([=InstanceName]);
		_[=relationValue.eName?lower_case]Repository.save([=relationValue.eName?lower_case]);
	}

	@Transactional
	public [=relationValue.eName]Entity Get[=relationValue.eName](Long [=InstanceName]Id, Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] foundRecord = _[=InstanceName]Repository.findById([=InstanceName]Id.longValue());
		
		Set<[=relationValue.eName]Entity> [=relationValue.eName?lower_case]s = foundRecord.get[=relationValue.eName]s();
		Iterator iterator = [=relationValue.eName?lower_case]s.iterator();
		while (iterator.hasNext()) { 
			[=relationValue.eName]Entity pe = ([=relationValue.eName]Entity) iterator.next();
			if (pe.getId() == [=relationValue.eName?lower_case]Id) {
				return pe;
			}
		}
		return null;
	}

	@Transactional
	public Set<[=relationValue.eName]Entity> Get[=relationValue.eName]s([=EntityClassName] [=InstanceName]) {
		
		[=EntityClassName] foundRecord = _[=InstanceName]Repository.findById([=InstanceName].getId().longValue());
		return foundRecord.get[=relationValue.eName]s();
	}
	</#if>
    </#list>
   </#if>
  </#list>
}
